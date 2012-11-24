describe Interactor::InteractorOperation do
  before do
    @target = Target.new
    @operation = Interactor::InteractorOperation.alloc.initWithTarget(@target)
    @queue = NSOperationQueue.alloc.init
  end

  after do
    @queue.waitUntilAllOperationsAreFinished()
  end

  it "subclasses NSOperation" do
    @operation.class.ancestors.should.include NSOperation
  end

  describe "#exception" do
    describe "when no exception is raised" do
      it "returns nil" do
        @queue.addOperation(@operation)
        @operation.waitUntilFinished()

        @operation.exception.should.be.nil
      end
    end

    describe "when an exception is raised" do
      it "returns the exception" do
        @target.exception = IndexError.new

        @queue.addOperation(@operation)
        @operation.waitUntilFinished()

        @operation.exception.should == @target.exception
      end
    end
  end

  describe "#main" do
    describe "when the operation has not been run" do
      it "invokes the target" do
        @queue.addOperation(@operation)
        @operation.waitUntilFinished()

        @target.called.should == 1
      end
    end

    describe "when the operation has been cancelled prior to starting" do
      it "does not invoke the target" do
        @operation.cancel()

        @queue.addOperation(@operation)
        @operation.waitUntilFinished()

        @target.called.should == 0
      end
    end
  end

  describe "#result" do
    before do
      @target.result = 42
    end

    describe "before starting the operation" do
      it "returns nil" do
        @operation.result.should.be.nil
      end
    end

    describe "when the operation has been cancelled" do
      it "returns nil" do
        @operation.cancel()

        @queue.addOperation(@operation)
        @operation.waitUntilFinished()

        @operation.result.should.be.nil
      end
    end

    describe "when the operation has finished" do
      it "returns the result of the target's #execute method" do
        @queue.addOperation(@operation)
        @operation.waitUntilFinished()

        @operation.result.should == 42
      end
    end
  end
end