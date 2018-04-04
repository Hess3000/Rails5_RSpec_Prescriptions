require 'rails_helper'

RSpec.describe Task do
	let(:task) { Task.new }

	it "Does not have task complete" do 
 		expect(task).not_to be_complete
 	end

 	it "Allows us to complete a task" do
 		task.mark_completed
 		expect(task).to be_complete
 	end
end

RSpec.describe "Velocity" do
	let(:task) { Task.new(size:3) }

	it "Does not count an incomplete task toward velocity" do
		expect(task).not_to be_a_part_of_velocity
		expect(task.points_toward_velocity).to eq(0)
	end

	it "Counts a recently completed task toward velocity" do
		task.mark_completed(1.day.ago)
		expect(task).to be_a_part_of_velocity
		expect(task.points_toward_velocity).to eq(3)
	end	

	it "Does not count a long ago completed task toward velocity" do
		task.mark_completed(6.months.ago)
		expect(task).not_to be_a_part_of_velocity
		expect(task.points_toward_velocity).to eq(0)
	end
end
