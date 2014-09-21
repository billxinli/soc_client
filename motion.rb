require 'pi_piper'
include PiPiper

after pin: 4, goes: :low do
  puts Time.now.to_s 
end
PiPiper.wait

