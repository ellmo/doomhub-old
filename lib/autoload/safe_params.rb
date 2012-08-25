module SafeParams

  PARAM_NAMES = [
    "controller",
    "action",
    "id",
    "project_id",
    "map_id"
  ]

  def filter_params(hash)
    unsafe_keys = hash.keys - PARAM_NAMES
    unsafe_keys.map {|key| hash.delete(key)}
    hash.update(hash){|k,v| v.gsub('/', '_')}
  end

  module_function :filter_params

end