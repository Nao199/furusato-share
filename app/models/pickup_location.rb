class PickupLocation < ActiveHash::Base
  self.data = [
    { id: 1, name: '---' },
    { id: 2, name: '1階のロビー待ち合わせ' },
    { id: 3, name: '宅配BOXに入れておくね' },
    { id: 4, name: '提供者部屋の玄関' },
    { id: 5, name: 'その他（別途調整）' },
  ]
  
  include ActiveHash::Associations
  has_many :foods
end