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

function English()

	local langNum = AddLanguage("English")

	AddTranslation(langNum, 1, "Usage: /register <password>")
	AddTranslation(langNum, 2, "You are already logged in!")
	AddTranslation(langNum, 3, "Your username is now registered.")
	AddTranslation(langNum, 4, "Your username is already registered.")
	AddTranslation(langNum, 5, "Usage: /login <password>")
	AddTranslation(langNum, 6, "This account has no password set.")
	AddTranslation(langNum, 7, "You are now logged in.")
	AddTranslation(langNum, 8, "You have entered a incorrect password.")
	AddTranslation(langNum, 9, "Somebody just tried to login in under your name.")
	AddTranslation(langNum, 10, "[Server] Already ingame.")
	AddTranslation(langNum, 11, "Please login before you start digging.")
	AddTranslation(langNum, 12, "Please login before you try placing blocks.")
	AddTranslation(langNum, 13, "[Server] Reloading.")

end
