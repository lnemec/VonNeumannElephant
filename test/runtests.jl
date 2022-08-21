using Test
import VonNeumannElephant as VNE

test_elephant = [[-60.0, -20.0, 60.0, 20.0, -60.0] [2.0, -50.0, -2.0, 50.0, 2.0]]
test_ts = [-3.141592653589793, -1.5707963267948966, 0.0, 1.5707963267948966, 3.141592653589793]

@testset "Elephant generation" begin
    # Write some tests!
    @test isequal(size(VNE.get_elephant(5, -pi, pi)), (5, 3) )
    @test isapprox(VNE.get_elephant(5, -pi, pi)[:, 2:3], test_elephant)
    @test isapprox(VNE.get_elephant(5, -pi, pi)[:, 1], test_ts)

end
