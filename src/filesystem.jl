#=================================================================================
    Metadata Dictionary Format

The metadata dictionary has keys which are Vector{Any}s with the function name
followed by the hashed arguments.
=================================================================================#
metadataFileName(dir::String) = joinpath(dir, METADATE_FILENAME)
loadMetadata_raw(dir::String) = deserialize(metadataFileName(dir))


"""
    loadMetadata(dir)

Load a metadata dictionary (the kind used by scribes) found in the directory `dir`.
If a file doesn't exist in the directory with the standard metadat filename 
(`Anamnesis.METADATE_FILENAME`), an empty `Dict` will be returned instead.
"""
function loadMetadata(dir::String)
    filename = metadataFileName(dir)
    if isfile(filename)
        return loadMetadata_raw(dir)
    end
    Dict()  # if file doesn't exist, return empty Dict
end


"""
    saveMetadata(dir, meta)

Saves the `Dict` `meta` to the directory `dir` in a file with the standard metadata file name
(`Anamnesis.METADATE_FILENAME`).
"""
function saveMetadata(dir::String, meta::Dict)
    serialize(joinpath(dir, METADATE_FILENAME), meta)
end


"""
    metadata(scr)

Gets the `Dict` from the `AbstractScribe` `scr` which would be stored as metadata.
Essentially, this is a dict with all the data that would be stored in the `scr.vals` dict
but without the actual function evaluation results.
"""
function metadata(s::AbstractScribe)
    meta = copy(s.vals)
    for (k, v) ∈ meta
        nv = Dict{Any,Any}(k_=>v_ for (k_, v_) ∈ v if k_ ≠ :val)  # store all but value
        meta[k] = nv
    end
    meta
end

"""
    loadfile(filename)

Loads a file using the appropriate deserialization method for the file extension.
"""
function loadfile(filename::String)
    ext = convert(String, split(filename, '.')[end])
    if ext == ".feather"
        return featherRead(filename)
    end
    deserialize(filename)
end


