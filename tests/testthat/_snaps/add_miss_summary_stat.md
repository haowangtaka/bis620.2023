# add_miss_summary_stat() works

    Code
      add_miss_summary_stat(studies, "phase", get_distinct(studies, "phase"), "NA")
    Output
      # A tibble: 9 x 2
        plot_col            n
        <ord>           <int>
      1 Early Phase 1     101
      2 NA               2074
      3 Not Applicable   3881
      4 Phase 1           752
      5 Phase 1/Phase 2   386
      6 Phase 2          1326
      7 Phase 2/Phase 3   133
      8 Phase 3           743
      9 Phase 4           604

