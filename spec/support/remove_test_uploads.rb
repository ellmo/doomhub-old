def remove_test_uploads
  dir = File.join(Rails.root, 'public', 'uploads', 'test')
  if File.directory? dir
    FileUtils.rm_rf dir
  end
end