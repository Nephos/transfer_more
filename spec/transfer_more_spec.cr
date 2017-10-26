require "./spec_helper"

describe TransferMore do
  it "works" do
    spawn { Kemal.run }
    url = `curl --progress-bar --upload-file README.md http://localhost:3000/readme.md`
    pp url
    data = `curl #{url}`
    data.should eq File.read("README.md")
  end
end
