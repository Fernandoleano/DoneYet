class AiCommandService
  require "net/http"
  require "uri"
  require "json"

  def initialize(user, query, context = {})
    @user = user
    @query = query
    @context = context || {}
    @api_key = ENV["LLM_API_KEY"]
    @model = ENV["LLM_MODEL"] || "gpt-4o"
  end

  def call
    if @api_key.present?
      process_with_llm
    else
      # Fallback for demonstration/development without API key
      mock_process
    end
  end

  private

  def process_with_llm
    # This is a simplified implementation targeting an OpenAI-compatible API
    # You can swap this URL for OpenRouter, Anthropic, etc.
    url = URI("https://api.openai.com/v1/chat/completions")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{@api_key}"

    system_prompt = <<~PROMPT
      You are an AI assistant for a project management app called "DoneYet".
      Your goal is to help the user manage their "Missions" (Tasks) and "Meetings" (Projects).

      Current User ID: #{@user.id}
      Current User Name: #{@user.name}

      Available Tools/Actions:
      1. LIST_MISSIONS: List missions assigned to the user.
      2. CREATE_MISSION: Create a new mission.

      Output Format:
      Return ONLY a valid JSON object. Do not include markdown formatting or backticks.

      Structure:
      {
        "action": "LIST_MISSIONS" | "CREATE_MISSION" | "REPLY",
        "data": { ... parameters for action ... },
        "message": "A natural language response to show the user"
      }

      For CREATE_MISSION, 'data' should contain:
      - title (string, required)
      - difficulty (string: 'easy', 'medium', 'hard', 'critical')
      - due_in_hours (integer, optional)

      Current Date: #{Time.current}
    PROMPT

    # Contextual Intelligence: Meeting/Project Awareness
    if @context["url"].to_s.include?("/meetings/")
      begin
        meeting_id = @context["url"].split("/meetings/").last.split("/").first
        meeting = Meeting.find_by(id: meeting_id)

        if meeting
          system_prompt += <<~CONTEXT

            === CURRENT FIELD INTEL (User is viewing this Project) ===
            Project Name: #{meeting.title || "Classified"}
            Status: #{meeting.status || "Active"}

            Active Operatives (Team):
            #{meeting.missions.includes(:agent).map { |m| m.agent&.name }.compact.uniq.join(", ")}

            Pending Missions (Tasks):
            #{meeting.missions.pending.map { |m| "- [#{m.difficulty}] #{m.title} (Assigned: #{m.agent&.name || 'Unassigned'})" }.join("\n")}

            INSTRUCTIONS:
            If the user asks "Summarize this" or "What is this?", refer to the project details above.
            If asked about team members, refer to the Active Operatives list.
          CONTEXT
        end
      rescue => e
        puts "Context Fetch Error: #{e.message}"
      end
    end

    request.body = JSON.dump({
      model: @model,
      messages: [
        { role: "system", content: system_prompt },
        { role: "user", content: @query }
      ],
      temperature: 0.7
    })

    begin
      response = http.request(request)
      result = JSON.parse(response.body)

      if response.code.to_i == 200
        content = result.dig("choices", 0, "message", "content")
        parsed_content = JSON.parse(content)
        execute_action(parsed_content)
      else
        { status: "error", message: "AI Provider Error: #{result['error']['message']}" }
      end
    rescue => e
      # Return the actual error to the chat UI so the user can see it
      { status: "error", message: "System Integrity Failure: #{e.message}" }
    end
  end

  def mock_process
    # Simple regex-based parser for demo purposes if no API key is set
    downcased_query = @query.downcase
    url = @context.dig("url") || ""

    if downcased_query.include?("create") && downcased_query.include?("mission")
      # Extract title: "create mission called X" or "create mission X"
      title = if downcased_query.include?("called")
                @query.split("called").last.strip
      else
                @query.split("mission").last.strip
      end

      execute_action({
        "action" => "CREATE_MISSION",
        "data" => { "title" => title, "difficulty" => "medium" },
        "message" => "Mission '#{title}' has been established. Good luck, Agent."
      })
    elsif downcased_query.include?("list") || downcased_query.include?("show")
      # Context-aware listing
      if url.include?("missions") || downcased_query.include?("mission")
         execute_action({
          "action" => "LIST_MISSIONS",
          "data" => {},
          "message" => "Retrieving active mission dossier..."
        })
      else
        { status: "success", message: "Please specify target: 'List missions' or 'List personnel'." }
      end
    elsif downcased_query.include?("status") || downcased_query.include?("report")
       page_name = url.split("/").last&.humanize || "Unknown Sector"
       { status: "success", message: "System operational. Secure connection established. Context: #{page_name}." }
    elsif downcased_query.include?("analyze")
       # Mock smart analysis
       { status: "success", message: "ANALYSIS COMPLETE:\n- 3 missions pending.\n- Success probability: 87%.\n- Key threat: Deadline approaching in 2 hours." }
    else
      { status: "success", message: "Command not recognized. Authorized inputs: 'Create mission [name]', 'List missions', 'Analyze'." }
    end
  end

  def execute_action(instruction)
    case instruction["action"]
    when "CREATE_MISSION"
      create_mission(instruction["data"])
    when "LIST_MISSIONS"
      list_missions
    when "REPLY"
      { status: "success", message: instruction["message"] }
    else
      { status: "error", message: "Unknown action: #{instruction['action']}" }
    end
  end

  def create_mission(data)
    mission = Mission.new(
      title: data["title"],
      difficulty: data["difficulty"] || "medium",
      agent: @user,
      status: :pending,
      # Defaulting required fields
      due_at: Time.current + (data["due_in_hours"] || 24).to_i.hours,
      meeting_id: @user.workspace&.meetings&.first&.id # Fallback to first available meeting/project context
    )

    # If we really can't find a meeting, we might fail validation, so we should handle that.
    # ideally we'd find a "General" meeting or create one, but for now let's check validation.

    if mission.save
      { status: "success", message: "Mission '#{mission.title}' created successfully! (Difficulty: #{mission.difficulty})" }
    else
      { status: "error", message: "Failed to create mission: #{mission.errors.full_messages.join(', ')}" }
    end
  end

  def list_missions
    # For Captains, show all workspace missions. For Agents, show assigned.
    scope = if @user.respond_to?(:captain?) && @user.captain? || @user.role == "captain"
              @user.workspace.missions
    else
              Mission.where(agent: @user)
    end

    # Check for overdue specifically (matches Dashboard logic)
    overdue_missions = scope.pending.where("due_at < ?", Time.current)

    # Recent Active
    active_missions = scope.where.not(status: :done).where.not(id: overdue_missions.pluck(:id)).order(due_at: :asc).limit(5)

    if active_missions.any? || overdue_missions.any?
      report = []

      if overdue_missions.any?
        report << "⚠️ CRITICAL ALERT: #{overdue_missions.count} MISSIONS OVERDUE"
        overdue_missions.each do |m|
           report << "- [OVERDUE] #{m.title} (Agent: #{m.agent&.name || 'Unassigned'})"
        end
        report << ""
      end

      if active_missions.any?
        report << "📋 Active Missions:"
        active_missions.each do |m|
          report << "- #{m.title} [#{m.difficulty.upcase}] (Due: #{m.due_at&.strftime('%H:%M')})"
        end
      end

      # Tactical Advice Logic
      priority_mission = overdue_missions.order(difficulty: :desc).first || active_missions.order(difficulty: :desc, due_at: :asc).first

      if priority_mission
        report << "" # Spacer
        report << "🛑 TACTICAL ADVICE:"
        report << "Prioritize '#{priority_mission.title}' immediately."
        report << "Reason: #{priority_mission.due_at < Time.current ? 'Mission is OVERDUE' : 'Approaching Deadline'} with #{priority_mission.difficulty.upcase} priority."
      end

      { status: "success", message: report.join("\n") }
    else
      { status: "success", message: "You have no active missions right now. Scope: #{scope.count} total." }
    end
  end
end
