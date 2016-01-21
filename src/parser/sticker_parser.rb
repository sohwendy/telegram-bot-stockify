STICKER = {
        "MACHIKO_BED" =>  "BQADBAADKwEAAljp-gN1zT2al2_CjgI",
        "MACHIKO_DOZE" =>  "BQADBAADIwEAAljp-gO2-1cfUb7lsAI",
        "MACHIKO_TV" =>  "BQADBAAD1wADWOn6A9VZisfkVwwJAg",
        "MACHIKO_BACKSIDE" =>  "BQADBAAD1QADWOn6A_2Oeakh7dn7Ag",
        "MACHIKO_SHOCK" =>  "BQADBAADxwADWOn6A6qE1_KO3-8LAg",
        # "MACHIKO_NO" =>  "BQADBAADvAADWOn6A0iyoknA72zzAg",
        # "MACHIKO_SLEEPLESS" =>  "BQADBAADuAADWOn6A6ztZANpJLlGAg",
        # "MACHIKO_CRY" => "BQADBAADzwADWOn6A5GLQPgD-8fhAg",
        "MACHIKO_SHY" =>  "BQADBAAD5wADWOn6A71WsUiIGKLeAg",
        # "MACHIKO_TISSUE" => "BQADBAAD-wADWOn6A3iWbo0KYrftAg",
        "MACHIKO_LOVE" => "BQADBAADFQEAAljp-gMEzpDjYmR-sgI",
        "ONION_THINK" =>  "BQADAwADRAIAArs-WAahQJ28iDf7xwI",
        "ONION_SPEECHLESS" =>  "BQADAwADNgIAArs-WAa1R5AJ_PcIiwI",
        "ONION_SHOCK" =>  "BQADAwADVAIAArs-WAZwVR9xCi-TugI",
        "ONION_PUZZLE" =>  "BQADAwAD3gMAArs-WAb1wLWJbc1RgQI",
        # "ONION_ANGRY" =>  "BQADAwADawQAArs-WAZFKcMQ8LwRSQI",
        # "ONION_DOWN" =>  "BQADAwADZAIAArs-WAb1GgABcpnzExQC",
        # "ONION_GOOD" =>  "BQADAwADQgIAArs-WAbB7nzs56aZGgI",
        # "PANDA_DARN" =>  "BQADBAAD9woAAhh_0AJSmCWCWJA7JAI",
        "PANDA_KO" =>  "BQADBAADKwsAAhh_0AKKCquv7ITcIAI",
        "PANDA_CORNER" =>  "BQADBAADOQsAAhh_0AI2mBce7nnW9QI",
        "GURETAMA_LAZY" => "BQADBQADTgADLXDJAvWp4pJS6l6RAg",
        "GURETAMA_HIDE" =>  "BQADBQADegADLXDJAlYnGy9xNqZOAg",
        # "GURETAMA_SIT" =>  "BQADBQADfAADLXDJAscscnTvu7caAg",
        "FAT_RABBIT_DOZE" =>  "BQADAgADxAAD3aEBAAHzUo7ylDsm-gI",
        "TUZIKI_SLEEP" =>  "BQADBQADkAADhKDXAqkOG48Kdvt8Ag",
        "RACOON_SLEEP" =>  "BQADBAADMwIAAmONagABu635srr8N-0C"
}

class StickerParser
  def initialize
    @random = Random.new(Time.now.to_i)
  end

  def get_sticker(name)
    if name
      STICKER[name]
    else
      get_random_sticker
    end
  end

  def get_random_sticker
    index = @random.rand(STICKER.length)
    STICKER[STICKER.keys[index]]
  end
end
