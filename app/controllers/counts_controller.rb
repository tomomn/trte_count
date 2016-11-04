class CountsController < ApplicationController
  def index
  end

  def create

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
    # def trte_all_count(links)
    #     agent = Mechanize.new
    #     sum = 0
    #     links.each do |link|
    #     page = agent.get('http://trte.jp' + link)
    #     elements = page.search('.l-view-body-inner')
    #       elements.each do |ele|
    #         ele_count = ele.inner_text.length
    #       sum += ele_count
    #       end
    #     end
    #   puts sum
    #   return sum
    # end

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

      def trte_all_count(counts)
          sum = 0
        counts.each do |count|
          sum += count
        end
          return sum
      end


      @url = params[:url]
      @title = get_title
      @get_urls = get_url
      @trte_wa_counts = trte_wa_count(@get_urls)
      # @trte_all_counts = trte_all_count(@get_urls)

      @trte_all_counts = trte_all_count(@trte_wa_counts)




  end

end



# class CountsController < ApplicationController
#   def index
#   end

#   def create
#     def trte_all_count
#       links = []
#       agent = Mechanize.new
#       next_url = params[:url]

# #タイトルURLに紐づく話ページのURLを全て取得する。
#       while true do
#         current_page = agent.get(next_url)
#         elements = current_page.search('.infinite-scroll a')
#         elements.each do |ele|
#           links << ele.get_attribute('href')
#         end

#         next_link = current_page.at('.item-index div')
#         next_url = next_link.get_attribute('data-next-url')
#         break if next_url == ""
#       end

#         sum = 0
#         links.each do |link|   ##ここで、取得したい話ページURL全て配列
#          sum += trte_wa_count('http://trte.jp' + link)
#         end
#       puts sum  #話ごと文字数の合計を表示
#       return sum
#     end

# ##話ごとの文字数をカウント
#       def trte_wa_count(link)
#         agent = Mechanize.new
#         page = agent.get(link)
#         elements = page.search('.l-view-body-inner')
#         elements.each do |ele|
#           ele_count = ele.inner_text.length
#           puts ele_count
#           return ele_count
#         end
#       end


#       @sum_all = trte_all_count
#   end

# end
