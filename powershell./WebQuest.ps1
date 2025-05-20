#Script to get informations about one page and accepted methods in it  

param($var1)
echo ""
$web = Invoke-WebRequest -uri $var1 -Method Options
echo "++++++++++ SERVER INFORMATION ++++++++++"
echo ""
$web.headers.server
echo ""
echo "+++++++++++++ ACCEPTED METHODS  ++++++++++++++"
$web.headers.allow
echo ""
echo "++++++++++++ RELATED LINKS ++++++++++++++"
echo ""
$web2 = Invoke-WebRequest -uri $var1
$web2.links.href | Select-String .com
echo ""
echo "++++++++++++++++++++++++++++++++++++++++++++"
