# ProductLookup module takes care of querying Amazon API for products
#
# load_product_batch method receives batches of Amazon ASINS in the format of:
#   FORMAT: String => "ASIN1,ASIN2,ASIN3,..,ASIN10"
#
# And returns and array containing a hash for each product composed by
# the product attributes and its similar products, in the format of:
#   FORMAT: Array => [
#     {
#       small_image: ''
#       medium_image: ''
#       large_image: ''
#       title: ''
#       department: ''
#       price: ''
#       brand: ''
#       buylink: ''
#       asins_of_sim_prods: 'ASIN1,ASIN2,ASIN3,...,ASIN10'
#     },
#     ...
#   ]
#
# get_ten_asins returns an array of ten random ASINs

module ProductLookup
  # make instance methods available as class methods
  extend self

  def load_product_batch asins
    res = get_parsed_response(get_params(asins))

    if is_valid_response?(res)
      items = res["ItemLookupResponse"]["Items"]["Item"]
      return normalize_response(items)
    end

    []
  end

  def get_params asins
    {
      'Operation'     => 'ItemLookup',
      'IdType'        => 'ASIN',
      'ResponseGroup' => 'Large',
      'ItemId'        => asins
    }
  end

  def get_parsed_response(params)
    req = ProductLookup.get_request_object
    Response.new(req.get(query: params)).to_h
  end

  def normalize_response(item_response)
    [item_response].flatten.map { |item| get_attribute_hash(item) }.compact
  end

  def is_valid_response?(response)
    response["ItemLookupResponse"]["Items"]["Request"]["IsValid"] == "True"
  end

  def get_request_object
    req = Vacuum.new('US')
    req.configure(
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'] ,
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      associate_tag: ENV['ASSOCIATE_TAG']
    )
  end

  def get_attribute_hash item_response
    begin
      {
        asin: item_response["ASIN"],
        small_image: item_response["SmallImage"]["URL"],
        medium_image: item_response["MediumImage"]["URL"],
        large_image: item_response["LargeImage"]["URL"],
        title: item_response["ItemAttributes"]["Title"],
        department: item_response["ItemAttributes"]["Department"],
        price: item_response["ItemAttributes"]["ListPrice"] ? item_response["ItemAttributes"]["ListPrice"]["FormattedPrice"] : '-',
        brand: item_response["ItemAttributes"]["Brand"],
        buylink: item_response["DetailPageURL"],
        asins_of_sim_prods: get_similar_products(item_response).join(",")
      }
    rescue
      nil
    end
  end

  def get_similar_products item_response
    return [] if item_response["SimilarProducts"].nil?
    similar_product = item_response["SimilarProducts"]["SimilarProduct"]
    [similar_product].flatten.map { |product| product["ASIN"] }
  end

  def get_ten_asins(gender = '', page = '', keywords = '', brand = '')
    department = '1040658' if gender == 'mens'
    department = '1040660' if gender == 'womens'
    page = _get_random_page if page.empty?
    brand = _get_random_brand if brand.empty?
    req = ProductLookup.get_request_object
    params = {
      'Operation'     => 'ItemSearch',
      'SearchIndex'   => 'Apparel',
      'ResponseGroup' => 'ItemAttributes',
      'Brand'         =>  brand,
      'Sort'          => 'salesrank',
      'BrowseNode'    =>  department,
      'Keywords'      =>  keywords,
      'ItemPage'      =>  page
    }
    res = Response.new(req.get(query: params)).to_h
    return nil if res["ItemSearchResponse"]["Items"]["Request"]["Errors"]
    item_response = normalize_to_array(res["ItemSearchResponse"]["Items"]["Item"])
    item_response.map { |product| product["ASIN"]}
  end

  def normalize_to_array(item_search_response)
    [item_search_response].flatten
  end

  def _get_random_page
    rand(1..3).to_s
  end


  def _get_random_brand
    "10 Crosby Derek Lam,143Fashion,1WorldSarong,2b by bebe,800Colors,9XIS,A. Byer,A.B.S. by Allen Schwartz,Activewear Apparel,ADAR UNIFORMS,Addison,Adrianna Papell,AGB,Aidan Mattox,Alex Evenings,Ali Ro,Alice &amp; Trixie,Alivila.Y Fashion,Alki'i,Allegra K,Allen Allen,Allison Brittney,Alternative,Alternative Apparel,Amanda Uprichard,AMC,American Apparel,Amour,Amy Matto,Angelina,Angie,Anna Sui,Anna-Kaci,Anne Klein,Arc'teryx,Arden B.,Argenti,Artwedding,aryn K,As U Wish,Ashley Stewart,Autograph,Aventura,AxParis,Azules,Back From Bali,Bailey 44,Banned Alternative Wear,Basix,BB Dakota,BCBGeneration,BCBGMAXAZRIA,BCO,bebe,Bella,Best Cody,Billabong,BLACK,Blaque Label,Bloom's Outlet,Blue Plate,Bluejuice,Bobi,BombayFashions,Bonus,Boulee,Brinley Co,Bslingerie,C &amp; C California,CA Fashion,Calvin Klein,Calvin Klein Jeans,camilla and marc,Canari,Candela,Capelli New York,Carol Wright Gifts,Carole,Carve Designs,CATHERINE CATHERINE MALANDRINO,Catherine Malandrino,CC USA,Celebrity Inspired,Charlie Jade,Chaus,Cheap Monday,Chelsea Studio,Chic Star,Christopher Fischer,Classic Designs,ClosetOnline,CloudShop,CM,Collective Concepts,Columbia,Connected,COREY,Coupe Collection,Cynthia Rowley,Cynthia Steffe,Danny &amp; Nicole,David's Bridal,Design History,Desigual,Dessy,Diane Von Furstenberg,Diesel,Disney,DKNY Jeans,DKNYC,Dlass,Dolce Vita,dollhouse,Donna Morgan,Doublju,Dress Club!!,DV by Dolce Vita,Eddie Bauer,eight sixty,Elan,Element,ELIE TAHARI,Eliza J,Ella Moss,Ellen Tracy,Ellison,Ellos,Elope,EMU Australia,ERIN erin fetherston,Escada,Essentials,EuroBrand,Eva Franco,Evan Picone,Ever-Pretty,eVogues Apparel,Evolution by Cyrus,Eyeshadow,Fair Indigo,Fancy That Clothing,Fashion Love,Fashion Wardrobe,fashion.connection,Fashionomics,Fiesta Formals,FineBrandShop,Flying Tomato,Fred Perry,Frederick's of Hollywood,French Connection,Full Tilt,Funfash,Funktional,G by GUESS,G-Star,G2 Chic,Gabby Skye,Glam Attack,Glamorous,GOJANE,Goodtime,Greg Norman,Greylin,GUESS,GUESS by Marciano,Hailey by Adrianna Papell,Hailey by Adrianna Papell Women's Dresses,Halston Heritage,Heartloom,Heather,Hee Grand,Hey Viv !,Highwinwin,Hollister,Hollywood Star Fashion,HolyClothing,Hot &amp; Delicious,Hot Fash,Hot from Hollywood,Hot Topic,Hurley,Icebreaker,IGIGI,Iron Fist,Isaac Mizrahi,Ivy &amp; Blu Maggy Boutique,J-Mode,Jack,Jax,Jessica Howard,Jessica London,Jessica Simpson,Jessie G.,Joe Browns,Johnny Was,Joie,Jolt,Jones New York,Jostar,Jovani,JS,Juicy Couture,Julian Taylor,JUMP,KAMALIKULTURE,Karen Kane,Kasper,Kenneth Cole,kensie,Kiwi Co.,Kiyonna,KY INTERNATIONAL,La Femme,LabelShopper,Landybridal,LAT Sportswear,laundry by SHELLI SEGAL,Lauren by Ralph Lauren,Le Suit,Lennie for Nina Leonard,Leos Mexican Imports,Libian,Lilla P,Lilly Pulitzer,Lindy Bop,LnLClothing,London Times,LookbookStore,LOVE ADY,Lovers+Friends,Lucky Brand,LUCY LOVE,Madison Marcus,Magaschoni,Maggy London,MANGO,Mara Hoffman,Marina Rinaldi,maxandcleo,Maxchic,MAXSTUDIO,MB,McGinn,Meilan,Merrell,Metal Mulisha,Michael Stars,MINKPINK,MISS SIXTY,Miusol,Mod-O-Doc,Monrow,Monsoon,Moonar,Moontree,Mountain Hardwear,Muzzanghee,My Michelle,National,Neon Buddha,NI9NE,Nicole Miller,Nikita,Nine West,Nollie,NY Collection,NY Deal,O'Neill,Olive &amp; Oak,On Trend,Only Necessities,Onyx Nite,Orvis,Pacific Clothing Company,Pacific Legend,Pacific Legend Dress,PacificPlex,Paper Crown,Paradise Found,Parker,Parkhurst,Patterson J. Kincaid,Patty,Peach Couture,Pendleton,phistic,Pink Owl Apparel,Pink Queen,Pink Tartan,PinupClothingOnline,Plenty by Tracy Reese,prAna,Pretty Attitude,Private Label,Quiksilver,Rachel Pally,Rachel Roy Collection,RALPH LAUREN,Rampage,Rebecca Minkoff,Rebecca Taylor,Red,Rip Curl,Roamans,Robert Graham,Robert Rodriguez,Roberto Cavalli,Romeo &amp; Juliet Couture,Rory Beca,Roxy,Royal Robbins,Ruby Rox,RVCA,Sakkas,Samanthas Style Shoppe,Sami + Dani,Sandra Darren,Sealed with a Kiss Designs Plus Size,Sherri Hill,Silly yogi,Skelapparel,Skirt Sports,Smooth Fashion,Sofie,Sofishie,Soho Girls,SOLILOR,Sourpuss,Southpole,Soybu,Splendid,SSQ Fashion,Stanzino,Star Vixen,Style,Sugarlips,Sunvary,Susana Monaco,Suzi Chin,Switchblade Stiletto,T Tahari,Taillissime,Tart Collections,Taylor Dresses,Tbags Los Angeles,Tea Collection,Ted Baker,The Cool Cube,The Evening Store,THEO. s,Theory,Three Dots,Three Dots Red,Tiana B,ToBeInStyle,Tommy Hilfiger,TOP,TopTie,Tracy Reese,Trina Turk,Trixxi,True Rock,Tt Collection,Tucker,Twelfth Street by Cynthia Vincent,Twenty8Twelve,U.S. Polo Assn.,u.s.p.a.,Ulla Popken,Unif,US Fairytailes,VA VA VOOM,Velvet by Graham &amp; Spencer,Vince Camuto,VIP,VIP BOUTIQUE,Vivienne Westwood,Vivienne Westwood for Lee,Volcom,VonVonni,WallFlower Jeans,Weston Wear,Wet Seal,WHAT GOES AROUND COMES AROUND,Whatabeautifullife,WIIPU,Wilt,Woman Within,Wool Overs,Woolrich,Wrangler,XOXO,Yelete,Yoana Baraschi,YogaColors,Young, Fabulous &amp; Broke,YoursClothing,Zehui,Zicac".split(',').sample
  end
end


if $0 == __FILE__
  require 'vacuum'
  require 'awesome_print'
  require_relative '../../config/environment'

  ProductLookup.load_product_batch("B00CHHCCDC,B00CHHBDQE,B00DH9OSWM,B00CHHBDA0,B00CHHBDAU,B00CHHB2QU,B00CHHB2T2,B00DH9NB52,B00DP34DW0")
  # ProductLookup.get_ten_asins
  # ProductLookup.load_product_batch("B00DQN7NA8")
  # ap ProductLookup.load_product_batch("B00CHHB2QU")
end
