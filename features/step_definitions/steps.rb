path = "C:/Users/Honey-cake/RubymineProjects/untitled/chromedriver/chromedriver.exe"
Given(/^I open a browser$/) do
  @driver = Selenium::WebDriver.for :chrome, driver_path: path
end

UrlDestructed = Struct.new(:base, :page, :end, keyword_init: true)

# Разбиваем адрес страницы на части, чтобы потом из них склеить новый адрес, когда встретим страницу вообще без ссылки
def splitUrl(url)
  breaker = url.rindex('/')
  point = url.index('.', breaker)
  return UrlDestructed.new(base: url[..breaker], page: url[breaker + 1 .. point - 1], end: url[point..])
end

When(/^I start checking pages$/) do
  #в качестве точки входа первая страница с ссылкой
  Array toVisit = ["http://qa-web-test-task.s3-website.eu-central-1.amazonaws.com/1.html"]
  #массив с номерами страниц без видимых ссылок
  Array pageNoLink = []
  #Начинаем перебирать страницы, пока есть ссылки
  while not toVisit.empty? do
    @driver.navigate.to toVisit.pop

    elems = @driver.find_elements(tag_name: 'a')
    #когда ссылки нет даже скрытой, собираем страницу из текущей, добавляя в номер +1, чтобы перейти к следующей
    if elems.empty?
      #Если увидели последнюю, останавливаемся
      if @driver.find_element(tag_name: "body").text.include? "последняя страница"
        break
      end

      urlSplitted = splitUrl(@driver.current_url)
      pageNoLink.push(urlSplitted.page)
      newPage = Integer(urlSplitted.page) + 1
      toVisit.push("#{urlSplitted.base}#{newPage}#{urlSplitted.end}")

      next
    end

    elems.each do |elem|
      if not elem.displayed?
        urlSplitted = splitUrl(@driver.current_url)
        pageNoLink.push(urlSplitted.page)
      end
      toVisit.push(elem.attribute('href'))
    end
  end

  printf("Номера страниц без ссылки: %s\n", pageNoLink.join(","))
end

Then(/^I close a browser$/) do
  @driver.quit
end