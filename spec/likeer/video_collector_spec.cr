require "../spec_helper"

VIDEO_IDS = %w[
  6869760684842841392 6868091316954232112 6867348635504375088
  6855798605157004592 6850278717483152688 6849907632308778288
  6832467144509257008 6829869032892560688 6829497943423218992
  6829126862543811888 6828756292765513008 6828385203296171312
  6828013602725721392 6827643032947422512 6827271952068015408
  6826900862598673712 6826529777424299312 6826158696544892208
  6825787611370517808 6825416526196143408 6825045441021769008
  6824674351552427312 6824303266378052912 6823931670102570288
  6823560584928195888 6823189499753821488 6822818410284479792
  6822447844801148208 6822076755331806512 6821705670157432112
  6821334589278025008 6820963499808683312 6820592418929276208
  6820221333754901808 6819849728889484592 6819478643715110192
  6819107558540735792 6818736988762436912 6818365899293095216
  6817995333809763632 6817994303017612592 6817623728944346416
  6817252648064939312 6816881047494489392 6816510473421223216
  6816138877145740592 6815767791971366192 6815396706796991792
  6815025621622617392 6814654536448242992 6814283451273868592
  6813912366099494192 6813541280925119792 6813170195750745392
  6812799110576370992 6812428540798072112 6812057455623697712
  6811686374744290608 6811314769878873392 6810943684704498992
]

describe LikeeScraper::VideoCollector do
  describe ".collect_each" do
    it "iterates through all pages of the user profile" do
      WebMock
        .stub(:post, "https://api.like-video.com/likee-activity-flow-micro/videoApi/getUserVideo")
        .with(
          body: {uid: "111", lastPostId: "", count: 100, tabType: 0}.to_json
        )
        .to_return(
          status: 200, body: mocked_profile_feed_page_1
        )

      WebMock
        .stub(:post, "https://api.like-video.com/likee-activity-flow-micro/videoApi/getUserVideo")
        .with(
          body: {uid: "111", lastPostId: "6821705670157432112", count: 100, tabType: 0}.to_json
        )
        .to_return(
          status: 200, body: mocked_profile_feed_page_2
        )

      WebMock
        .stub(:post, "https://api.like-video.com/likee-activity-flow-micro/videoApi/getUserVideo")
        .with(
          body: {uid: "111", lastPostId: "6810943684704498992", count: 100, tabType: 0}.to_json
        )
        .to_return(
          status: 200, body: mocked_profile_feed_page_3
        )

      WebMock.stub(:get, /video.like.video/)

      archived_ids = [] of String

      LikeeScraper::VideoCollector.collect_each(uid: "111") do |video|
        archived_ids << video.id
      end

      archived_ids.should eq(VIDEO_IDS)
    end
  end
end
