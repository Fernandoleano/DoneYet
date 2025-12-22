export class MeetAddon {
  constructor() {
    this.session = null;
  }

  async init() {
    console.log("Initializing Meet Addon...");
    try {
      // 1. Initialize SDK Client
      const session = await meet.addon.createAddonSession({
        cloudProjectNumber: "930643907126",
      });
      this.session = session;

      // 2. Get Context
      const context = await session.createMeetingClient();
      console.log("Connected to Meeting:", context.meetingCode);

      // 3. Handshake with Rails
      this.handshake(context.meetingCode);
    } catch (error) {
      console.error("Meet SDK Init Failed (Simulating?):", error);

      // Fallback for Simulator
      if (window.location.search.includes("simulator")) {
        console.warn("Running in Simulator Mode");
        // No handshake needed, as simulator loads the iframe directly with ID
      }
    }
  }

  handshake(code) {
    // Redirect the iframe to the specific meeting context
    window.location.href = `/meetings/meet?code=${code}`;
  }
}

// Auto-start
document.addEventListener("DOMContentLoaded", () => {
  // Only run if we are NOT already in a specific meeting and SDK is present
  if (
    typeof meet !== "undefined" &&
    window.location.pathname === "/meet/landing"
  ) {
    new MeetAddon().init();
  }
});
