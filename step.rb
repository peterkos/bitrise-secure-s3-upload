require 'aws-sdk-s3'
require_relative 'params'
require_relative 'log/log'

begin
  # Params
  params = Params.new
  params.print
  params.validate

  Log.verbose = (params.verbose_log == 'yes')

  Log.debug("Bucket: #{params.bucket}")
  Log.debug("Region: #{params.region}")

  if params.bucket.to_s.empty? || params.region.to_s.empty? || params.client_id.to_s.empty? || params.filename.to_s.empty? || params.secret.to_s.empty?
    raise 'Error: Not all fields set cannot proceed!'
  end
  
  filename = ENV['BITRISE_BUILD_SLUG'] + '.zip'

  s3 = Aws::S3::Resource.new(region: params.region, credentials: Aws::Credentials.new(params.client_id, params.secret))

  obj = s3.bucket(params.bucket).object(filename)

  obj.upload_file(params.filename)
rescue => ex
  puts
  Log.error('Error:')
  Log.error(ex.to_s)
  puts
  Log.error('Stacktrace (for debugging):')
  Log.error(ex.backtrace.join("\n").to_s)
  exit 1
end