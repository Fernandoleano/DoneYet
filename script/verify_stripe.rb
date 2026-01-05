# script/verify_stripe.rb
puts "--- Stripe Verification ---"
key = Stripe.api_key
if key.nil?
  puts "❌ Stripe API Key is NIL."
  puts "   Check config/credentials.yml.enc or config/initializers/stripe.rb"
elsif key.start_with?("sk_live_")
  puts "✅ Stripe API Key is configured (Live Mode)."
  puts "   Prefix: #{key[0..7]}..."
elsif key.start_with?("sk_test_")
  puts "⚠️ Stripe API Key is configured (Test Mode)."
  puts "   Prefix: #{key[0..7]}..."
else
  puts "❓ Stripe API Key format unknown."
  puts "   Prefix: #{key[0..7]}..."
end

begin
  # optional: Try to retrieve account details (requires 'stripe' gem)
  # account = Stripe::Account.retrieve()
  # puts "✅ Connected to Account: #{account.email}"
rescue => e
  puts "⚠️ Could not verify connection: #{e.message}"
end
puts "---------------------------"
