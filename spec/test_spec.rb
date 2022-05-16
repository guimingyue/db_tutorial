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

  it 'allows printing out the structure of a 4-leaf-node btree' do
    script = [
      "insert 11 user11 person11@example.com",
      "insert 13 user13 person13@example.com",
      "insert 18 user18 person18@example.com",
      "insert 31 user31 person31@example.com",
      "insert 34 user34 person34@example.com",
      "insert 20 user20 person20@example.com",
      "insert 19 user19 person19@example.com",
      "insert 7 user7 person7@example.com",
      "insert 29 user29 person29@example.com",
      "insert 28 user28 person28@example.com",
      "insert 22 user22 person22@example.com",
      "insert 37 user37 person37@example.com",
      "insert 27 user27 person27@example.com",
      "insert 33 user33 person33@example.com",
      "insert 30 user30 person30@example.com",
      "insert 35 user35 person35@example.com",
      "insert 21 user21 person21@example.com",
      "insert 36 user36 person36@example.com",
      "insert 9 user9 person9@example.com",
      "insert 12 user12 person12@example.com",
      "insert 26 user26 person26@example.com",
      "insert 17 user17 person17@example.com",
      "insert 25 user25 person25@example.com",
      "insert 16 user16 person16@example.com",
      "insert 32 user32 person32@example.com",
      "insert 10 user10 person10@example.com",
      "insert 23 user23 person23@example.com",
      "insert 14 user14 person14@example.com",
      "insert 24 user24 person24@example.com",
      "insert 15 user15 person15@example.com",
      "insert 8 user8 person8@example.com",
      "insert 5 user5 person5@example.com",
      "insert 2 user2 person2@example.com",
      "insert 4 user4 person4@example.com",
      "insert 6 user6 person6@example.com",
      "insert 1 user1 person1@example.com",
      ".btree",
      ".exit",
    ]
    result = run_script(script)

    expect(result[30...(result.length)]).to match_array([
      "db > Tree:",
      "- internal (size 3)",
      "  - leaf (size 7)",
      "    - 1",
      "    - 2",
      "    - 3",
      "    - 4",
      "    - 5",
      "    - 6",
      "    - 7",
      "  - key 7",
      "  - leaf (size 8)",
      "    - 8",
      "    - 9",
      "    - 10",
      "    - 11",
      "    - 12",
      "    - 13",
      "    - 14",
      "    - 15",
      "  - key 15",
      "  - leaf (size 7)",
      "    - 16",
      "    - 17",
      "    - 18",
      "    - 19",
      "    - 20",
      "    - 21",
      "    - 22",
      "  - key 22",
      "  - leaf (size 8)",
      "    - 23",
      "    - 24",
      "    - 25",
      "    - 26",
      "    - 27",
      "    - 28",
      "    - 29",
      "    - 30",
      "db > ",
    ])
  end
end