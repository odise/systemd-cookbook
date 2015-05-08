
def combine(input, pre: "", post: "", connector: "")
  if !input 
    return 
  end
  out = input.map! { |element|
     pre + element + post
  }
  return out.join(connector)
end

