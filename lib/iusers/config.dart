Uri getLoginUrl() {
  return Uri.parse('http://192.168.31.28:3000/login');
  //   return Uri.parse('http://10.220.20.12/index.php/home/login');
}

Uri getLoginProcessUrl() {
  return Uri.parse('http://10.220.20.12/index.php/home/loginProcess');
}

Map<String, String> getHeaders(String? ciSession) {
  return {
    "Host": "10.220.20.12",
    "Cache-Control": "max-age=0",
    "Upgrade-Insecure-Requests": "1",
    "Origin": "http://10.220.20.12",
    "Content-Type": "application/x-www-form-urlencoded",
    "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.5195.102 Safari/537.36",
    "Accept":
        "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
    "Cookie": ciSession ?? '',
  };
}
