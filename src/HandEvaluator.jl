module HandEvaluator

export HandIndexer, size, indexLast, unindex

using Libdl

using OMPEval_jll
const lib = dlopen("libOMPEval")

const eval5CardFunc = dlsym(lib, "evaluate_5c")
const eval7CardFunc = dlsym(lib, "evaluate_7c")

function eval5Card(c1, c2, c3, c4, c5)
    return ccall(eval5CardFunc, UInt16, (UInt8,UInt8,UInt8,UInt8,UInt8), c1 - 1, c2 - 1, c3 - 1, c4 - 1, c5 - 1)
end

println(eval5Card([52,49,1,2,3]...))

end