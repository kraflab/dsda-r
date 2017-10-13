def require_one_of(*keys, args)
  if keys.count { |key| args[key].present? } == 0
    raise GraphQL::ExecutionError.new("At least one of #{keys} is required")
  end
end

def find_by_one_of!(*keys, args, klass)
  require_one_of *keys, args
  keys.each do |key|
    return klass.find_by(key => args[key]) if args[key]
  end
end
