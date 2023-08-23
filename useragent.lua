local _M = { _VERSION = "0.0.1" }

local mstr = require('mystring')
--local utf8 = require('utf8')


local Windows      = "Windows"
local WindowsPhone = "Windows Phone"
local Android      = "Android"
local MacOS        = "macOS"
local IOS          = "iOS"
local Linux        = "Linux"
local ChromeOS     = "ChromeOS"

local Opera            = "Opera"
local OperaMini        = "Opera Mini"
local OperaTouch       = "Opera Touch"
local Chrome           = "Chrome"
local HeadlessChrome   = "Headless Chrome"
local Firefox          = "Firefox"
local InternetExplorer = "Internet Explorer"
local Safari           = "Safari"
local Edge             = "Edge"
local Vivaldi          = "Vivaldi"

local GoogleAdsBot        = "Google Ads Bot"
local Googlebot           = "Googlebot"
local Applebot            = "Applebot"
local Bingbot             = "Bingbot"

local FacebookApp  = "Facebook App"
local InstagramApp = "Instagram App"
local TiktokApp    = "TikTok App"
local Twitterbot          = "Twitterbot"
local FacebookExternalHit = "facebookexternalhit"

function _M.getUserAgentName(userAgent)
    local tokens = _M.parseUserAgent(userAgent)
    for k, v in pairs(tokens) do
        if mstr.startswith(k, "http://") or mstr.startswith(k, "https://") then
            tokens[k] = nil
        end
    end

    local os = nil

    if tokens["Android"] ~= nil then
        os = Android
    end

    if tokens["iPhone"] ~= nil then
        os = IOS
    end

    if tokens["iPad"] ~= nil then
        os = IOS
    end

    if tokens['Windows NT'] ~= nil then
        os = Windows
    end

    if tokens['Windows Phone OS'] ~= nil then
        os = WindowsPhone
    end

    if tokens['Macintosh'] ~= nil then
        os = MacOS
    end

    if tokens['Linux'] ~= nil then
        os = Linux
    end

    if tokens['Cros'] ~= nil then
        os = ChromeOS
    end

    if tokens['Googlebot'] ~= nil then
        return Googlebot
    end

    if tokens['Applebot'] ~= nil then
        return Applebot
    end

    if tokens['Opera Mini'] ~= nil and tokens['Opera Mini'] ~= "" then
        return OperaMini
    end

    if tokens['OPR'] ~= nil and tokens['OPR'] ~= "" then
        return Opera
    end

    if tokens['OPT'] ~= nil and tokens['OPT'] ~= "" then
        return OperaTouch
    end

    if tokens['OPiOS'] ~= nil and tokens['OPiOS'] ~= "" then
        return Opera
    end

    if tokens['CriOS'] ~= nil and tokens['CriOS'] ~= "" then
        return Chrome
    end

    if tokens['FxiOS'] ~= nil and tokens['FxiOS'] ~= "" then
        return Firefox
    end

    if tokens['Firefox'] ~= nil and tokens['Firefox'] ~= '' then
        return Firefox
    end

    if tokens['Vivaldi'] ~= nil and tokens['Vivaldi'] ~= '' then
        return Vivaldi
    end

    if tokens['MSIE'] ~= nil then
        return InternetExplorer
    end

    if tokens['EdgiOS'] ~= nil and tokens['EdgiOS'] ~= "" then
        return Edge
    end

    if tokens['Edge'] ~= nil and tokens['Edge'] ~= '' then
        return Edge
    end

    if tokens['Edg'] ~= nil and tokens['Edg'] ~= '' then
        return Edge
    end

    if tokens['EdgA'] ~= nil and tokens['EdgA'] ~= '' then
        return Edge
    end

    if tokens['bingbot'] ~= nil and tokens['bingbot'] ~= '' then
        return Bingbot
    end

    if tokens['YandexBot'] ~= nil and tokens['YandexBot'] ~= '' then
        return 'YandexBot'
    end

    if tokens['SamsungBrowser'] ~= nil and tokens['SamsungBrowser'] ~= '' then
        return 'Samsung Browser'
    end

    if tokens['HeadlessChrome'] ~= nil and tokens['HeadlessChrome'] ~= '' then
        return HeadlessChrome
    end

    if _M.existsAny(tokens, "AdsBot-Google-Mobile", "Mediapartners-Google", "AdsBot-Google") then
        return GoogleAdsBot
    end

    if tokens['Yahoo Ad monitoring'] ~= nil then
        return 'Yahoo Ad monitoring'
    end

    if tokens['XiaoMi'] ~= nil then
        local miui = tokens['XiaoMi']
        if mstr.startswith(miui, 'MiuiBrowser') then
            return 'Miui Browser'
        end
    end

    if tokens['FBAN'] ~= nil then
        return FacebookApp
    end

    if tokens['FB_IAB'] ~= nil then
        return FacebookApp
    end

    if _M.tbStartsWith(tokens, 'Instagram') then
        return InstagramApp
    end

    if tokens['BytedanceWebview'] ~= nil then
        return TiktokApp
    end

    if tokens['HuaweiBrowser'] ~= nil and tokens['HuaweiBrowser'] ~= '' then
        return 'Huawei Browser'
    end

    if tokens[Chrome] ~= nil and tokens[Safari] ~= nil then
        local name = _M.findBestMatch(tokens, true)
        if name ~= '' then
            return name
        end
    end

    if tokens['Chrome'] ~= nil then
        return Chrome
    end

    if tokens['Brave Chrome'] ~= nil then
        return Chrome
    end

    if tokens['Safari'] ~= nil then
        return Safari
    end

    if os == 'Android' and tokens['Version'] ~= nil and tokens['Version'] ~= '' then
        return 'Android browser'
    else
        local name = _M.findBestMatch(tokens, false)
        if name ~= '' then
            return name
        else
            return userAgent
        end
    end
end

function _M.findBestMatch(tokens, withVerOnly)
    local n = 2
    if withVerOnly then
        n = 1
    end

    local ignores = {Chrome, Firefox, Safari, "Version", "Mobile", "Mobile Safari", "Mozilla", "AppleWebKit", "Windows NT", "Windows Phone OS", Android, "Macintosh", Linux, "GSA", "CrOS", "Tablet"}

    for i=1,n do
        for k, v in pairs(tokens) do
            if _M.tbIn(ignores, k) then
            else
                local firstCharCode = string.byte(k:sub(1,1))
                if #k ~= 0 and firstCharCode >= 48 and firstCharCode <= 57 then
                    break
                end

                if i == 1 then
                    if v ~= nil and v ~= '' then
                        return k
                    end
                else
                    return k
                end
            end
        end
    end
    return ''
end

function _M.tbIn(tb, item)
    for _, v in pairs(tb) do
        if item == v then
            return true
        end
    end

    return false
end

function _M.tbStartsWith(tokens, prefix)
    for k, _ in pairs(tokens) do
        if mstr.startswith(k, prefix) then
            return true
        end
    end
    return false
end

function _M.existsAny(tokens, ...)
    local args = {...}
    for _, k in pairs(args) do
        for data, _ in pairs(tokens) do
            if data == k then
                return true
            end
        end
    end
    return false
end

function _M.dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. _M.dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

function _M.parseUserAgent(userAgent)
    local tokens = {}
    local slash = false
    local isURL = false

    local buff = {}
    local val = {}

    local parOpen = false
    local braOpen = false

    --    local byteUa = { utf8.byte(userAgent, 1, -1) }
    local byteUa = { string.byte(userAgent, 1, -1) }
    for i, c in pairs(byteUa) do
        if c == 41 then -- )
            local k, v = _M.addToken(buff, val, slash, isURL)
            if k ~= nil then
                tokens[k] = v
            end
            buff = {}
            val = {}
            slash = false
            isURL = false
            parOpen = false
        elseif (parOpen or braOpen) and c == 59 then  -- ;
            local k, v = _M.addToken(buff, val, slash, isURL)
            if k ~= nil then
                tokens[k] = v
            end
            buff = {}
            val = {}
            slash = false
            isURL = false
        elseif c == 40 then -- (
            local k, v = _M.addToken(buff, val, slash, isURL)
            if k ~= nil then
                tokens[k] = v
            end
            buff = {}
            val = {}
            slash = false
            isURL = false
            parOpen = true
        elseif c == 91 then -- [
            local k, v = _M.addToken(buff, val, slash, isURL)
            if k ~= nil then
                tokens[k] =v
            end
            buff = {}
            val = {}
            slash = false
            isURL = false
            braOpen = true
        elseif c == 93 then -- ]
            local k,v =_M.addToken(buff, val, slash, isURL)
            if k ~= nil then
                tokens[k] = v
            end
            buff = {}
            val = {}
            slash = false
            isURL = false
            braOpen = false
        elseif slash and c == 32 then
            local k, v = _M.addToken(buff, val, slash, isURL)
            if k ~= nil then
                tokens[k] = v
            end
            buff = {}
            val = {}
            slash = false
            isURL = false
        elseif slash then
            table.insert(val, c)
        elseif c == 47 and not isURL then
            local nowBuffStr = string.char(unpack(buff))
            if i ~= #byteUa and byteUa[i+1] == 47 and (mstr.endswith(nowBuffStr, "http:") or mstr.endswith(nowBuffStr, "https:")) then
                table.insert(buff, c)
                isURL = true
            else
                slash = true
            end
        else
            table.insert(buff, c)
        end
    end
    local k, v = _M.addToken(buff, val, slash, isURL)
    if k ~= nil then
        tokens[k] = v
    end
    buff = {}
    val = {}
    slash = false
    isURL = false
    return tokens
end

function _M.addToken(buff, val, slash, isURL)
    if #buff ~= 0 then
        local s = mstr.str_trim(string.char(unpack(buff)))
        if not _M.ignore(s) then
            if isURL then
                s = mstr.trimPrefix(s, "+")
            end

            if #val == 0 then
                local key, ver = _M.checkVer(s)
                return key, ver
            else
                return s, mstr.str_trim(string.char(unpack(val)))
            end
        end
    end
end

function _M.checkVer(s)
    local i = mstr.findLastOccurrence(s, " ")
    if i == nil then
        return s, ""
    end
    local mdata = string.sub(s, 1, i-1)
    local os1 = {"Linux", "Windows NT", "Windows Phone OS", "MSIE", "Android"}
    for _, v in pairs(os1) do
        if mdata == v then
            return mdata, string.sub(s, i+1)
        end
    end

    if mdata == "CrOS x86_64" or mdata == "CrOS aarch64" then
        local j = mstr.findLastOccurrence(mdata, " ")
        return string.sub(s, 1, j-1), string.sub(s, j+1, i-1)
    end

    return s, ""
end

function _M.ignore(s)
    local tags = {"KHTML, like Gecko", "U", "compatible", "Mozilla", "WOW64", "en", "en-us", "en-gb", "ru-ru"}
    for _, v in pairs(tags) do
        if s == v then
            return true
        else
            return false
        end
    end
end


return _M
