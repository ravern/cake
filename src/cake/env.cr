struct Cake::Env
  property verbose
  property timeout

  def initialize(@verbose : Bool, @timeout : Int32)
  end
end
