module PokerHandIsomorphism

export HandIndexer, size, indexLast, unindex

using ..PokerCard
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
    cardsPerRound::Vector{UInt8}
    function HandIndexer(cardsPerRound::Vector{T}) where {T <: Integer}
        handIndexer = new()
        handIndexer.rounds = length(cardsPerRound)
        handIndexer.cardsPerRound = UInt8[x for x in cardsPerRound]
        handIndexer.indexer = ccall(initFunc, Ptr{Cvoid}, (Cint, Ptr{UInt8}), handIndexer.rounds, handIndexer.cardsPerRound) 
        finalizer(x -> ccall(freeFunc, Cvoid, (Ptr{Cvoid},),handIndexer.indexer), handIndexer)
        return handIndexer
    end
end

function size(handIndexer::HandIndexer, round::Integer)
    return ccall(sizeFunc, UInt64, (Ptr{Cvoid}, Cint), handIndexer.indexer, round - 1)
end

function indexLast(handIndexer::HandIndexer, cards::Vector{Card})
    return ccall(indexFunc, UInt64, (Ptr{Cvoid}, Ptr{UInt8}), handIndexer.indexer, cards) + 1
end

function unindex(handIndexer::HandIndexer, round::Integer, index::Integer)
    numCards = sum(handIndexer.cardsPerRound[1:round])
    output = Vector{Card}(undef, numCards)
    ccall(unindexFunc, Cvoid, (Ptr{Cvoid}, Cint, UInt64, Ptr{UInt8}), handIndexer.indexer, round - 1, index - 1, output)
    return output
end

function unindex(handIndexer::HandIndexer, round::Integer, index::Integer, output::Vector{Card})
    ccall(unindexFunc, Cvoid, (Ptr{Cvoid}, Cint, UInt64, Ptr{UInt8}), handIndexer.indexer, round - 1, index - 1, output)
    return output
end

end
