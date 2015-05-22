
def combine(input, pre: "", post: "", connector: "")
  if !input 
    return 
  end
  out = input.map! { |element|
    if element.length > 0
      pre + element + post
    else
      ""
    end
  }
  out.delete("")
  return out.join(connector)
end

