names = %w(Bomber Pepe Kaira Rikito Jun Dave Rob Ken Ichiro Mie)
0.upto(9) do |idx|
  Member.create(
    name: names[idx],
    email: "#{names[idx]}@example.com",
    admin: (idx == 0),
    password: "djbomber",
    password_confirmation: "djbomber",
    activated: true,
    activated_at: Time.zone.now
  )
end

0.upto(29) do |idx|
  Member.create(
    name: "Pepe#{idx + 1}",
    email: "Pepe#{idx+1}@example.com",
    admin: false,
    password: "password",
    password_confirmation: "password",
    activated: true,
    activated_at: Time.zone.now
  )
end

body =
  "マヌカハニーはその高い殺菌作用から1990年代より、民間医療としてだけでなく近代医療にも有効であるはちみつかどうかが研究されてきました。\n\n" +
  "高い抗菌活性力を持つマヌカハニーは一般的な腸内の悪玉菌の活動の抑制から殺菌までを行うことが可能で、臨床実験では数年間抗生物質を投与しても治療できなかった胃腸疾患が、マヌカハニーを用いた場合短期間で治療できたという例まであります。。" +
  "特に食品としての栄養価も高く、抗生物質と違い副作用の可能性も無いことから摂取するリスクがごく少ないのもマヌカハニーが健康食品として人気を集めている理由の一つでしょう。\n\n" +
  "ピロリ菌、大腸炎、腸球菌などの胃腸疾患の改善に役に立ちます。"

0.upto(9) do |idx|
  Article.create(
    title: "マヌカハニーの効果・効能#{idx}",
    body: body,
    released_at: 8.days.ago.advance(days: idx),
    expired_at: 2.days.ago.advance(days: idx),
    member_only: (idx % 3 == 0)
  )
end

0.upto(29) do |idx|
  Article.create(
    title: "Article#{idx+10}",
    body: "blah, blah, blah...",
    released_at: 100.days.ago.advance(days: idx),
    expired_at: nil,
    member_only: false
  )
end

body =
  "ハーブティーは、ブレンドやその比率で味が変わります。\n\n" +
  "糖を抑えるハーブ、ギムネマを飲んでみました。" +
  "ギムネマは糖の吸収と関わりのある不思議な植物です。" +
  "このギムネマは甘いものを感じなくなるので、デザートなどへの欲求を抑えることができるそうです。\n\n" +
  "不思議な世界観に導いてくれる味のような気がしました。"

%w(Bomber Pepe Kaira).each do |name|
  member = Member.find_by(name: name)
  0.upto(9) do |idx|
    Entry.create(
      author: member,
      title: "ハーブティー#{idx}",
      body: body,
      posted_at: 10.days.ago.advance(days: idx),
      status: %w(draft member_only public)[idx % 3]
    )
  end
end
