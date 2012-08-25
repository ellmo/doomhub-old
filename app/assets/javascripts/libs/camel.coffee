$ ->
  String::toCamel = ->
    @replace /((^|\_)[a-z])/g, ($1) ->
      $1.toUpperCase().replace "_", ""