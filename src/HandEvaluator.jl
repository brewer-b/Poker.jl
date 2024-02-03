module PokerHandEvaluator

export handRanks, evaluate5c, evaluate7c, evaluatePartial

using ..PokerCard
using DataDeps

register(DataDep("PokerHandRanks",
        """
        Poker Hand Ranks LUT
        """,
        "https://github.com/christophschmalhofer/poker/raw/master/XPokerEval/XPokerEval.TwoPlusTwo/HandRanks.dat",
        "ad00f3976ad278f2cfd8c47b008cf4dbdefac642d70755a9f20707f8bbeb3c7e"
    ))


function loadHandRanks()
    handRanks = Vector{Int32}(undef, 32487834);
    read!(datadep"PokerHandRanks/HandRanks.dat", handRanks)
    return handRanks
end

const handRanks = loadHandRanks()

function evaluate7c(hr,c1::Card,c2::Card,c3::Card,c4::Card,c5::Card,c6::Card,c7::Card)
    p = hr[53 + c1 + 2]
    p = hr[p + c2 + 2]
    p = hr[p + c3 + 2]
    p = hr[p + c4 + 2]
    p = hr[p + c5 + 2]
    p = hr[p + c6 + 2]
    p = hr[p + c7 + 2]
    return p
end

evaluate7c(c1::Card,c2::Card,c3::Card,c4::Card,c5::Card,c6::Card,c7::Card) = evaluate7c(handRanks,c1,c2,c3,c4,c5,c6,c7)

function evaluate5c(hr,c1::Card,c2::Card,c3::Card,c4::Card,c5::Card)
    p = hr[53 + c1 + 2]
    p = hr[p + c2 + 2]
    p = hr[p + c3 + 2]
    p = hr[p + c4 + 2]
    p = hr[p + c5 + 2]
    return hr[p + 2]
end

evaluate5c(c1::Card,c2::Card,c3::Card,c4::Card,c5::Card) = evaluate5c(handRanks,c1,c2,c3,c4,c5)

function evaluatePartial(card::Card,p=53)
    return hr[p + card + 2]
end

end