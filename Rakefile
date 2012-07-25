require 'rubygems'

task :publish do
  
  require 'fog'

  s3 = YAML.load_file("s3.yml")
  
  # create a connection
  storage = Fog::Storage.new(
    :provider                 => "AWS",
    :aws_secret_access_key    => "#{s3['secret-key']}",
    :aws_access_key_id        => "#{s3['key']}"
  )
  
  bucket = storage.directories.get(s3["bucket"])
  
  puts "Deleting files in bucket"
  bucket.files.each do |file|
    puts file.key
    file.destroy
  end

  Dir["web/**/*"].each do |path|
    next if File.directory?(path)
    key = path.split("/")[1..-1].join("/")
    puts "Updating '#{key}'"
    file = bucket.files.get(key)
    file ||= begin
      file = bucket.files.create(
        :key    => key,
        :public => true
      )
    end
    file.body = File.open(path)
    file.save
  end
  
end
