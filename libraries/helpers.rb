require 'shellwords'

def shell_sanitize(str)
  str ? str.strip.shellescape : ''
end
