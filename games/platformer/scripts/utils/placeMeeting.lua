-- a = beginContact a
-- b = beginContact b
-- aFixture = object1.physics.fixture
-- bFixture = object2.physics.fixture

function placeMeeting(a, b, aFixture, bFixture)
    --check if a or b is a object1
    if a == aFixture or b == aFixture then
        --check if a or b is the object2
        if a == bFixture or b == bFixture then
            return true
        end
        else return false
    end
end