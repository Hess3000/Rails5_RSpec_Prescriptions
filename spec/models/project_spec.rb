require 'rails_helper'

RSpec.describe Project do
	let(:project) { Project.new }
	let(:task) { Task.new }

	it "Properly handles a blank project" do
		expect(project.completed_velocity).to eq (0)
		expect(project.current_rate).to eq (0)
		expect(project.projected_days_remaining).to be_nan
		expect(project).not_to be_on_schedule
	end

	it "Considers a project with no tasks to be done" do
		expect(project).to be_done
	end

	it "Knows that a project with an incomplete task is not done" do
		project.tasks << task
		expect(project).not_to be_done
	end
end

RSpec.describe "Estimates" do
	let(:project) { Project.new }
	let(:newly_done) { Task.new(size: 3, completed_at: 1.day.ago)}
	let(:old_done) { Task.new(size: 2, completed_at: 6.months.ago)}
	let(:small_not_done) { Task.new(size: 1)}
	let(:large_not_done) { Task.new(size: 4)}

	before(:example) do
		project.tasks = [old_done, newly_done, small_not_done, large_not_done]
	end

	it "Can calculate total size" do 
		expect(project.total_size).to eq(10)
	end
 
	it "Can calculate remaining size" do
		expect(project.remaining_size).to eq(5)
	end

	it "Knows its velocity" do
		expect(project.completed_velocity).to eq(3)
	end

	it "Knows its rate" do
		expect(project.current_rate).to eq(1.0 / 7)
	end

	it "Knows its projected days remaining" do
		expect(project.projected_days_remaining).to eq(35)
	end

	it "Knows its on schedule" do
		project.due_date = 6.months.from_now
		expect(project).to be_on_schedule
	end

end
