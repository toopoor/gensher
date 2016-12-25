namespace :reviews do
  desc 'Add base reviews'
  task add_base: :environment do
    return unless Review.count.zero?
    data = [
      {
        author_id: 13,
        moderated: true,
        body: 'Я в МЛМ уже около 10 лет, уже давно думал о чем-то подобном. Я был страшно рад, когда узнал о General Sherman. Это именно то, чего мне до сих пор не хватало'
      },
      {
        author_id: 488,
        moderated: true,
        body: 'Впервые встречаю проект, в котором команда строится практически сама − нужно только вначале немного подтолкнуть'
      },
      {
        author_id: 22,
        moderated: true,
        body: 'Я поражена, как легко бывает строить команду и зарабатывать. В GS мне за месяц удалось выйти на результат, которого раньше ждала по пол-года'
      }
    ]
    Review.create(data)
  end
end
