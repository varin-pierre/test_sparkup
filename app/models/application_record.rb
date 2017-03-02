class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  def self.save(upload)
    name = upload['datafile'].original_filename
    directory = 'public/data'
    path = File.join(directory, name)
    File.open(path, 'wb') { |f| f.write(upload['datafile'].read) }
  end
end
