require 'spec_helper'

describe Twilreapi::ActiveBiller::UnicefIO::Biller do
  include EnvHelpers

  class DummyCdr
    attr_accessor :file

    def initialize(raw_cdr)
      self.file = StringIO.new(raw_cdr)
    end
  end

  let(:sample_cdr_path) { "./spec/fixtures/cdr.json" }
  let(:sample_cdr) { File.read(sample_cdr_path) }
  let(:raw_cdr) { sample_cdr }
  let(:dummy_cdr) { DummyCdr.new(raw_cdr) }

  # Environment configuration
  let(:bill_block_seconds) { "15" }
  let(:per_minute_call_rate_to_telesom) { 400000 }
  let(:per_minute_call_rate_to_hormuud) { 700000 }
  let(:per_minute_call_rate_to_golis) { 700000 }
  let(:per_minute_call_rate_to_somtel) { 500000 }
  let(:per_minute_call_rate_to_nationlink) { 500000 }

  def setup_scenario
    stub_env(
      :"twilreapi_active_biller_unicef_io_bill_block_seconds" => bill_block_seconds,
      :"twilreapi_active_biller_unicef_io_per_minute_call_rate_to_telesom" => per_minute_call_rate_to_telesom,
      :"twilreapi_active_biller_unicef_io_per_minute_call_rate_to_hormuud" => per_minute_call_rate_to_hormuud,
      :"twilreapi_active_biller_unicef_io_per_minute_call_rate_to_golis" => per_minute_call_rate_to_golis,
      :"twilreapi_active_biller_unicef_io_per_minute_call_rate_to_somtel" => per_minute_call_rate_to_somtel,
      :"twilreapi_active_biller_unicef_io_per_minute_call_rate_to_nationlink" => per_minute_call_rate_to_nationlink,
    )
  end

  before do
    setup_scenario
  end

  describe "#calculate_price_in_micro_units" do
    let(:result) { subject.calculate_price_in_micro_units }
    let(:call_direction) { nil }
    let(:billsec) { nil }
    let(:sip_to_user) { nil }

    let(:raw_cdr) {
      cdr = JSON.parse(sample_cdr)
      cdr_variables.delete_if { |k, v| v.nil? }.each do |key, value|
        cdr["variables"][key] = value == false ? nil : value
      end
      cdr.to_json
    }

    def cdr_variables
      {
        "direction" => call_direction,
        "billsec" => billsec,
        "sip_to_user" => sip_to_user
      }
    end

    def setup_scenario
      super
      subject.options = {:call_data_record => dummy_cdr}
    end

    context "where the call direction is inbound" do
      let(:call_direction) { "inbound" }
      let(:billsec) { 100 }
      it { expect(result).to eq(0) }
    end

    context "where the call direction is outbound" do
      let(:call_direction) { "outbound" }

      let(:telesom_number)  { "252634000613" }
      let(:golis_number)  { "252904000613" }
      let(:nationlink_number)  { "252694000613" }
      let(:somtel_number)  { "252654000613" }
      let(:hormuud_number)  { "252614000613" }

      context "and unless otherwise specified the destination operator is 'hormuud' and the billsec is:" do
        let(:sip_to_user) { hormuud_number }

        context "0" do
          let(:billsec) { 0 }
          it { expect(result).to eq(0) }
        end

        context "1" do
          let(:billsec) { 1 }
          it { expect(result).to eq(175000) }

          context "destination operator: telesom" do
            let(:sip_to_user) { telesom_number }
            it { expect(result).to eq(100000) }
          end

          context "destination operator: golis" do
            let(:sip_to_user) { golis_number }
            it { expect(result).to eq(175000) }
          end

          context "destination operator: somtel" do
            let(:sip_to_user) { somtel_number }
            it { expect(result).to eq(125000) }
          end

          context "destination operator: nationlink" do
            let(:sip_to_user) { nationlink_number }
            it { expect(result).to eq(125000) }
          end
        end

        context "15" do
          let(:billsec) { 15 }
          it { expect(result).to eq(175000) }
        end

        context "16" do
          let(:billsec) { 16 }
          it { expect(result).to eq(350000) }
        end

        context "30" do
          let(:billsec) { 30 }
          it { expect(result).to eq(350000) }
        end

        context "31" do
          let(:billsec) { 31 }
          it { expect(result).to eq(525000) }
        end

        context "45" do
          let(:billsec) { 45 }
          it { expect(result).to eq(525000) }
        end

        context "46" do
          let(:billsec) { 46 }
          it { expect(result).to eq(700000) }
        end

        context "60" do
          let(:billsec) { 60 }
          it { expect(result).to eq(700000) }
        end

        context "61" do
          let(:billsec) { 61 }
          it { expect(result).to eq(875000) }
        end
      end
    end
  end
end
