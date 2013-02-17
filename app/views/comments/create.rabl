# "object false" solution comes from
# https://github.com/nesquena/rabl/issues/174
# https://github.com/nesquena/rabl/pull/183
# https://github.com/nesquena/rabl/issues/216

object false

child @comments do
  extends 'comments/comments'
end


node(:pagination) do |p|
  { :page => @comments.current_page,
    :total_pages => @comments.total_pages,
    :first => @comments.first_page?,
    :last => @comments.last_page? }
end