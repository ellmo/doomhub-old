module FG
  def self.new(*args)
    FactoryGirl.create(*args)
  end

  def self.gen(*args)
    FactoryGirl.generate(*args)
  end
end