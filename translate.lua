-- Copyright (c) 2013 Alexander Harkness

-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject to
-- the following conditions:

-- The above copyright notice and this permission notice shall be included
-- in all copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
-- OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
-- CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
-- TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
-- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

-- Configuration

local defaultLanguage = "English"
local languagesEnabled = {}
table.insert(languagesEnabled, "English")

-- Globals

TRANSLATIONS		= {}
LANGUAGES		= {}
DEFAULTLANGUAGENUMBER	= nil

-- Code Start

function InitTranslations()

	LOG("Translations iit...")

	for i=1, #languagesEnabled do
		_G[languagesEnabled[1]]()
	end

end

function AddLanguage(languageName)

	local languageNumber = (# LANGUAGES) + 1

	table.insert(LANGUAGES, languageName)
	table.insert(TRANSLATIONS, {})

	if languageName == defaltLanguage then
		DEFAULTLANGUAGENUMBER = languageNumber
	end

	return languageNumber

end

function GetLanguageIDByName(languageName)

	for i=1, # LANGUAGES do

		if LANGUAGES[i][2] == languageName then
			return i
		end

	end

	return DEFAULTLANGUAGENUMBER

end

function AddTranslation(languageNumber, translationNumber, translationText)

	if LANGUAGES[languageNumber] == nil then
		return true
	end

	table.insert(TRANSLATIONS[languageNumber], translationText)

	return false

end

function GetTranslation(languageNumber, playerName, translationNumber)

	if languageNumber == 0 and playerName ~= 0 then

		local IniFile = cIniFile(PLUGIN:GetLocalDirectory() .. "/langprefs.ini")
		IniFile:ReadFile()

		local languagePreference = IniFile:GetValueSet("players", playerName)

		if languagePreference == "" then
			return TRANSLATIONS[DEFAULTLANGUAGENUMBER][translationNumber]
		else
			return TRANSLATIONS[GetLanguageIDByName(languagePreference)][translationNumber]
		end

	elseif languageNumber == 0 and playerName == 0 then
		return TRANSLATIONS[DEFAULTLANGUAGENUMBER][translationNumber]
	else
		return TRANSLATIONS[languageNumber][translationNumber]
	end

end
