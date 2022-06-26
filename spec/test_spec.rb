describe 'database' do
  before do
    `rm -rf test.db`
  end

  def run_script(commands)
    raw_output = nil
    IO.popen("./db test.db", "r+") do |pipe|
      commands.each do |command|
        begin
          pipe.puts command
        rescue Errno::EPIPE
          break
        end
      end

      pipe.close_write

      # Read entire output
      raw_output = pipe.gets(nil)
    end
    raw_output.split("\n")
  end

  it 'splitting internal node with the max number of cells 3 by splitting leftmost leaf node' do
      array = [11,13,18,31,34,20,19,7,29,28,22,37,27,33,30,35,21,36,9,12,26,17,25,16,32,10,23,14,24,15,8,5,2,4,6,1,3]
      script = []
      array.map do |i|
          script.push("insert #{i} user#{i} person#{i}@example.com")
      end
      script.push(".btree", ".exit")
      result = run_script(script)
      expect(result[37...(result.length - 1)]).to match_array([
          "db > Tree:",
          "- internal (size 1)",
          "  - internal (size 1)",
          "    - leaf (size 7)",
          "      - 1",
          "      - 2",
          "      - 3",
          "      - 4",
          "      - 5",
          "      - 6",
          "      - 7",
          "    - key 7",
          "    - leaf (size 7)",
          "      - 8",
          "      - 9",
          "      - 10",
          "      - 11",
          "      - 12",
          "      - 13",
          "      - 14",
          "  - key 14",
          "  - internal (size 2)",
          "    - leaf (size 8)",
          "      - 15",
          "      - 16",
          "      - 17",
          "      - 18",
          "      - 19",
          "      - 20",
          "      - 21",
          "      - 22",
          "    - key 22",
          "    - leaf (size 8)",
          "      - 23",
          "      - 24",
          "      - 25",
          "      - 26",
          "      - 27",
          "      - 28",
          "      - 29",
          "      - 30",
          "    - key 30",
          "    - leaf (size 7)",
          "      - 31",
          "      - 32",
          "      - 33",
          "      - 34",
          "      - 35",
          "      - 36",
          "      - 37",
      ])
  end

  it 'splitting internal node with the max number of cells 3 by splitting the second leaf node' do
    array = [1, 2, 3, 4, 5, 6, 7, 8, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 22,21, 20, 19, 18, 17, 16, 14, 13, 12, 11, 10, 9, 15]
    script = []
    array.map do |i|
        script.push("insert #{i} user#{i} person#{i}@example.com")
    end
    script.push(".btree", ".exit")
    result = run_script(script)
    expect(result[35...(result.length - 1)]).to match_array([
      "db > Tree:",
      "- internal (size 1)",
      "  - internal (size 1)",
      "    - leaf (size 7)",
      "      - 1",
      "      - 2",
      "      - 3",
      "      - 4",
      "      - 5",
      "      - 6",
      "      - 7",
      "    - key 7",
      "    - leaf (size 7)",
      "      - 8",
      "      - 9",
      "      - 10",
      "      - 11",
      "      - 12",
      "      - 13",
      "      - 14",
      "  - key 14",
      "  - internal (size 2)",
      "    - leaf (size 7)",
      "      - 15",
      "      - 16",
      "      - 17",
      "      - 18",
      "      - 19",
      "      - 20",
      "      - 21",
      "    - key 21",
      "    - leaf (size 7)",
      "      - 22",
      "      - 23",
      "      - 24",
      "      - 25",
      "      - 26",
      "      - 27",
      "      - 28",
      "    - key 28",
      "    - leaf (size 7)",
      "      - 29",
      "      - 30",
      "      - 31",
      "      - 32",
      "      - 33",
      "      - 34",
      "      - 35",
    ])
  end

  it 'splitting internal node with the max number of cells 3 by splitting the third leaf node' do
      array = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,23,24,25,26,27,28,29,30,31,32,33,34,35,16,17,18,19,20,22,21]
      script = []
      array.map do |i|
          script.push("insert #{i} user#{i} person#{i}@example.com")
      end
      script.push(".btree", ".exit")
      result = run_script(script)
      expect(result[35...(result.length - 1)]).to match_array([
        "db > Tree:",
        "- internal (size 1)",
        "  - internal (size 1)",
        "    - leaf (size 7)",
        "      - 1",
        "      - 2",
        "      - 3",
        "      - 4",
        "      - 5",
        "      - 6",
        "      - 7",
        "    - key 7",
        "    - leaf (size 7)",
        "      - 8",
        "      - 9",
        "      - 10",
        "      - 11",
        "      - 12",
        "      - 13",
        "      - 14",
        "  - key 14",
        "  - internal (size 2)",
        "    - leaf (size 7)",
        "      - 15",
        "      - 16",
        "      - 17",
        "      - 18",
        "      - 19",
        "      - 20",
        "      - 21",
        "    - key 21",
        "    - leaf (size 7)",
        "      - 22",
        "      - 23",
        "      - 24",
        "      - 25",
        "      - 26",
        "      - 27",
        "      - 28",
        "    - key 28",
        "    - leaf (size 7)",
        "      - 29",
        "      - 30",
        "      - 31",
        "      - 32",
        "      - 33",
        "      - 34",
        "      - 35",
      ])
  end

  it 'splitting internal node with the max number of cells 3 by splitting the rightmost leaf node' do
    array = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35]
    script = []
    array.map do |i|
        script.push("insert #{i} user#{i} person#{i}@example.com")
    end
    script.push(".btree", ".exit")
    result = run_script(script)
    expect(result[35...(result.length - 1)]).to match_array([
      "db > Tree:",
      "- internal (size 1)",
      "  - internal (size 1)",
      "    - leaf (size 7)",
      "      - 1",
      "      - 2",
      "      - 3",
      "      - 4",
      "      - 5",
      "      - 6",
      "      - 7",
      "    - key 7",
      "    - leaf (size 7)",
      "      - 8",
      "      - 9",
      "      - 10",
      "      - 11",
      "      - 12",
      "      - 13",
      "      - 14",
      "  - key 14",
      "  - internal (size 2)",
      "    - leaf (size 7)",
      "      - 15",
      "      - 16",
      "      - 17",
      "      - 18",
      "      - 19",
      "      - 20",
      "      - 21",
      "    - key 21",
      "    - leaf (size 7)",
      "      - 22",
      "      - 23",
      "      - 24",
      "      - 25",
      "      - 26",
      "      - 27",
      "      - 28",
      "    - key 28",
      "    - leaf (size 7)",
      "      - 29",
      "      - 30",
      "      - 31",
      "      - 32",
      "      - 33",
      "      - 34",
      "      - 35",
    ])
  end
end