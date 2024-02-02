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
    @assert(round >= 1 && round <= handIndexer.rounds)
    return ccall(sizeFunc, UInt64, (Ptr{Cvoid}, Cint), handIndexer.indexer, round - 1)
end

function indexLast(handIndexer::HandIndexer, cards::Vector{Card})
    u8Cards = UInt8[card.value - 1 for card in cards]
    return ccall(indexFunc, UInt64, (Ptr{Cvoid}, Ptr{UInt8}), handIndexer.indexer, u8Cards) + 1
end

function unindex(handIndexer::HandIndexer, round::Integer, index::Integer)
    @assert(round >= 1 && round <= handIndexer.rounds)
    @assert(index >= 1 && index <= size(handIndexer, round))
    numCards = sum(handIndexer.cardsPerRound[1:round])
    output = Vector{UInt8}(undef, numCards)
    ccall(unindexFunc, Cvoid, (Ptr{Cvoid}, Cint, UInt64, Ptr{UInt8}), handIndexer.indexer, round - 1, index - 1, output)
    cards = [Card(x + 1) for x in output]
    return cards
end

end
