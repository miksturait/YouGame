## Core extensions
Dir.glob("lib/core_ext/**/*.rb").sort.each do |file|
  require_dependency file.gsub(/^lib\//, '')
end