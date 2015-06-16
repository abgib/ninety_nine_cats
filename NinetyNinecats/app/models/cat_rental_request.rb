# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :integer          not null, primary key
#  cat_id     :integer          not null
#  start_date :date             not null
#  end_date   :date             not null
#  status     :string(255)      default("Pending"), not null
#  created_at :datetime
#  updated_at :datetime
#

class CatRentalRequest < ActiveRecord::Base
  belongs_to :cat,
    class_name: 'Cat',
    foreign_key: :cat_id,
    primary_key: :id

  after_initialize do |cat_rental_request|
    cat_rental_request.status ||= "Pending"
  end

  validates :status, inclusion: { in: %w(Pending Approved Denied),
    message: "%{value} is not a valid status"}
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validate :no_approved_requests

  def overlapping_requests
    overlap_cond = <<-SQL
      NOT ((:start_date > cat_rental_requests.end_date) OR
        (:end_date < cat_rental_requests.start_date)) AND
        cat_rental_requests.id != :id
      SQL

    CatRentalRequest.where(overlap_cond, :start_date => start_date,
      :end_date => end_date, :id => id)
  end

  def overlapping_approved_requests
    approve_cond = <<-SQL
        status = "Approved"
    SQL
    overlapping_requests.where(approve_cond)
  end

  def no_approved_requests
    unless overlapping_approved_requests.empty?
      errors.add(:approval_status, "There is already an approved request!")
    end
  end

  def self.all_cats
    find_by_sql(<<-SQL)
      SELECT
        id,
        name
      FROM
        cats
    SQL
  end

end
