class Count < ActiveRecord::Base


#タイトル名を取得する
    def get_title
      agent = Mechanize.new
      next_url = params[:url]
      current_page = agent.get(next_url)
      elements = current_page.search('.item-data h2')
      ele_title = elements.inner_text
      return ele_title
    end

#タイトルURLに紐づく話ページのURLを全て取得する。
    def get_url
      links = []
      agent = Mechanize.new
      next_url = params[:url]

      while true do
        current_page = agent.get(next_url)
        elements = current_page.search('.infinite-scroll a')
        elements.each do |ele|
          links << ele.get_attribute('href')
        end

        next_link = current_page.at('.item-index div')
        next_url = next_link.get_attribute('data-next-url')
        break if next_url == ""
      end
      return links
    end

##合計文字数をカウント
    def trte_all_count(links)
        agent = Mechanize.new
        sum = 0
        links.each do |link|
        page = agent.get('http://trte.jp' + link)
        elements = page.search('.l-view-body-inner')
          elements.each do |ele|
            ele_count = ele.inner_text.length
          sum += ele_count
          end
        end
      puts sum
      return sum
    end

##話ごとの文字数をカウント
      def trte_wa_count(links)
        agent = Mechanize.new
        wa_counts = []
        links.each do |link|
        page = agent.get('http://trte.jp' + link)
        elements = page.search('.l-view-body-inner')
          elements.each do |ele|
            ele_count = ele.inner_text.length
            wa_counts << ele_count
          end
        end
      return wa_counts
      end

  
end
