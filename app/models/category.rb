class Category < ActiveHash::Base
  self.data = [
    { id: 1, name: '---' },
    { id: 2, name: 'ふるさと納税返礼品' },
    { id: 3, name: '故郷の特産物' },
  ]

  include ActiveHash::Associations
  has_many :foods
end