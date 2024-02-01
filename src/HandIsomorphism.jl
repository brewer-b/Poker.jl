module HandIsomorphism

export HandIndexer, size, indexLast, unindex

using Libdl

using PokerIsomorphism_jll
const lib = dlopen("libHandIsomorphism")

const initFunc = dlsym(lib, "isomorphism_indexer_init")
const freeFunc = dlsym(lib, "isomorphism_indexer_free")
const sizeFunc = dlsym(lib, "isomorphism_indexer_size")
const indexFunc = dlsym(lib, "isomorphism_index_last")
const unindexFunc = dlsym(lib, "isomorphism_unindex")

mutable struct HandIndexer
    indexer::Ptr{Cvoid}
    rounds::Int64
    function HandIndexer(cardsPerRound::Vector{T}) where {T <: Integer}
        u8CardsPerRound::Vector{UInt8} = UInt8[x for x in cardsPerRound]
        handIndexer = new()
        handIndexer.rounds = length(u8CardsPerRound)
        handIndexer.indexer = ccall(initFunc, Ptr{Cvoid}, (Cint, Ptr{UInt8}), handIndexer.rounds, u8CardsPerRound) 
        finalizer(x -> ccall(freeFunc, Cvoid, (Ptr{Cvoid},),handIndexer.indexer), handIndexer)
        return handIndexer
    end
end

function size(handIndexer::HandIndexer, round::Integer)
    @assert(round >= 1 && round <= handIndexer.rounds)
    return ccall(sizeFunc, UInt64, (Ptr{Cvoid}, Cint), handIndexer.indexer, round - 1)
end

function indexLast(handIndexer::HandIndexer, cards::Vector{UInt8})
    cards .-= 1
    return ccall(indexFunc, UInt64, (Ptr{Cvoid}, Ptr{UInt8}), handIndexer.indexer, cards)
end

function unindex(handIndexer::HandIndexer, round::Integer, index::Integer, output::Vector{UInt8})
    ccall(unindexFunc, Cvoid, (Ptr{Cvoid}, Cint, UInt64, Ptr{UInt8}), handIndexer.indexer, round - 1, index - 1, output)
    return output
end

a = HandIndexer([2,3,1,1])
println(size(a,2))

end
