require 'net/http'
require 'json'
require "csv"

# 初期値
KEYID = "c16b6b597258c69d1c64781aa0e15728" # 2021/02/20まで利用可能
HIT_PER_PAGE = 100
PREF = "PREF13"
FREEWORD_CONDITION = 1
FREEWORD = "渋谷駅"
PARAMS = {"keyid":KEYID, "hit_per_page":HIT_PER_PAGE, "pref":PREF, "freeword_condition":FREEWORD_CONDITION, "freeword":FREEWORD}

def write_data_to_csv(params)
    restaurants = [["名称","住所","営業日","電話番号"]]
    uri = URI.parse("https://api.gnavi.co.jp/RestSearchAPI/v3/")
    uri.query = URI.encode_www_form(PARAMS)  
    json_res = Net::HTTP.get uri
    
    response = JSON.load(json_res)
    
    if response.has_key?("error") then
        puts "エラーが発生しました！"
    end
    for restaurant in response["rest"] do
        rest_info = [restaurant["name"], restaurant["address"], restaurant["opentime"], restaurant["tel"]]
        puts rest_info
        restaurants.append(rest_info)
    end
    
    File.open("restaurants_list.csv", "w") do |csv|
        restaurants.each do |rest_info|
            csv << rest_info
    end
    return puts restaurants
end

write_data_to_csv(PARAMS)