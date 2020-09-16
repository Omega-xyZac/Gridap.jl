struct ConstantField{T<:Number} <: NewField where N
  v::T
  function ConstantField{T}(v::T) where {T<:Number}
    new{typeof(v)}(v)
  end
end

ConstantField(v::Number) = ConstantField{typeof(v)}(v)

constant_field(v::Number) =  ConstantField(v)

function return_cache(f::ConstantField,x::AbstractArray{<:Point})
  nx = length(x)
  c = zeros(typeof(f.v),nx)
  CachedArray(c)
end

function evaluate!(c,f::ConstantField,x::AbstractArray{<:Point})
  nx = length(x)
  setsize!(c,(nx,))
  r = c.array
  for i in eachindex(x)
    @inbounds r[i] = f.v
  end
  r
end

# Array

function return_cache(f::AbstractArray{<:ConstantField{T}},x::AbstractArray{<:Point}) where T
  nx = length(x)
  sv = size(f)
  s = (nx,sv...)
  c = zeros(T,s)
  CachedArray(c)
end

function evaluate!(c,f::AbstractArray{<:ConstantField{T}},x::AbstractArray{<:Point}) where T
  nx = length(x)
  sv = size(f)
  s = (nx,sv...)
  setsize!(c,s)
  cis = CartesianIndices(f)
  r = c.array
  for i in eachindex(x)
    for ci in cis
      @inbounds r[i,ci] = f[ci].v
    end
  end
  r
end

# Gradients

function return_gradient_cache(f::ConstantField{T},x) where T
  E = return_gradient_type(T,first(x))
  c = zeros(E,length(x))
  CachedArray(c)
end

function evaluate_gradient!(c,f::ConstantField,x)
  nx = length(x)
  if size(c) != nx
    # s = (nx,size(f)...)
    setsize!(c,(nx,))
    c .= zero(eltype(c))
  end
  c
end

function return_hessian_cache(f::ConstantField{T},x) where T
  E = return_gradient_type(T,first(x))
  F = return_gradient_type(E,first(x))
  c = zeros(F,length(x))
  CachedArray(c)
end

function evaluate_hessian!(c,f::ConstantField,x)
  evaluate_gradient!(c,f,x)
end

# Gradient of arrays

const ConstantFieldArray{F,N} = FieldGradientArray{ConstantField{F},N}

function return_gradient_cache(f::AbstractArray{<:ConstantField{T}},x) where T
  E = return_gradient_type(T,first(x))
  s = (length(x), size(f)...)
  c = zeros(E,s)
  CachedArray(c)
end

function evaluate_gradient!(c,f::AbstractArray{<:ConstantField},x)
  nx = length(x)
  if size(c) != nx
    s = (nx,size(f)...)
    setsize!(c,s)
    c .= zero(eltype(c))
  end
  c
end

function return_hessian_cache(f::AbstractArray{<:ConstantField{T}},x) where T
  E = return_gradient_type(T,first(x))
  F = return_gradient_type(E,first(x))
  s = (length(x), size(f)...)
  c = zeros(F,s)
  CachedArray(c)
end

function evaluate_hessian!(c,f::AbstractArray{<:ConstantField},x)
  nx = length(x)
  if size(c) != nx
    s = (nx,size(f)...)
    setsize!(c,s)
    c .= zero(eltype(c))
  end
  c
end