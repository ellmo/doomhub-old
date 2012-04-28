module SafeParams

  PARAM_NAMES = [
    "controller",
    "action",
    "project_id",
    "map_id"
  ]

  def filter_params(hash)
    unsafe_keys = hash.keys - PARAM_NAMES
    unsafe_keys.map {|key| hash.delete(key)}
    hash
  end

end