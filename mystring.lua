local _M = { _VERSION = '0.15' }

function _M.str_trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function _M.trimPrefix(str, char)
    local pattern = "^" .. char .. "+"
    local result = string.gsub(str, pattern, "")
    return result
end


function _M.split_string(s, delimiter)
    local result = {};
    if s == nil then
        return result
    end
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function _M.startswith(str, prefix)
    local res = string.match(string.lower(str), '^'..prefix)
    if res ~= nil then
        return true
    else
        return false
    end
end

function _M.endswith(str, postfix)
    local res = string.match(string.lower(str), postfix..'$')
    if res ~= nil then
        return true
    else
        return false
    end
end

function _M.findLastOccurrence(str, substr)
    local lastIndex = nil
    local start = 1

    while true do
        local nextIndex = string.find(str, substr, start, true)
        if not nextIndex then
            break
        end
        lastIndex = nextIndex
        start = nextIndex + 1
    end

    return lastIndex
end

return _M
