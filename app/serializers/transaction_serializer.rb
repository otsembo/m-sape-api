class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :party_b, :amount, :date

  def party_b
    User.find(self.object.user_id).email
  end

  def date
    self.object.created_at.strftime("%m/%d/%Y %H:%M:%S")
  end

end
