class HiringController < ApplicationController
  def overview
    @resume_submitted = Candidate.resume_submitted(25)
    @pending = Candidate.pending(10)
    @archived = (Candidate.rejected(5) + Candidate.accepted(5)).sort_by{|c| c.updated_at }.reverse
  end
end
